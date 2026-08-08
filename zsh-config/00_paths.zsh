export PATH="/home/yy/anaconda3/bin:$PATH"

# Conda initialization (fix for conda init conflicts)
if [ -f "/home/yy/anaconda3/etc/profile.d/conda.sh" ]; then
    source "/home/yy/anaconda3/etc/profile.d/conda.sh"
fi
